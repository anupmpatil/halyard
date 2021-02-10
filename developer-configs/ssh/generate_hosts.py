#!/usr/bin/env python

import argparse
import sys

__DEV_CONTROL_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaanfewqzj6sfouxpf5uzoi2fjoxkavxecsok5nuiy2g27r5ssw7qva'
__DEV_CONTROL_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaapvd53hscz7jnzoazsv3ulp3dtbwn34y2czu74srabi6bjciiq7fa'
__DEV_MANAGEMENT_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaachohyaxwwnfcfpdga7kvc6jae5fl2c6tor4uq7t7cjqmhw2hyogq'
__DEV_DATA_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaay735nx4ueuzyobl325y2thvybwfju633ihqrn7g5y2y6nlq3ibra'

__PREPROD_CONTROL_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaa6g47mcelo2sy5x2by5ctyboxzjue6a4ejl5rwz356p6jjewwxjaa'
__PREPROD_CONTROL_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaau6lkwuipovqefnhqgtwkk5guwgxzevvtyenjee5sbi4upc4n554a'
__PREPROD_MANAGEMENT_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaanb7lg7aq3kibqmwzzf7mm4ecu7lzyafdwa7kevt6p4kvvnje2ura'
__PREPROD_DATA_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaawmqozxu6pjtii2u3a2c54ftd6hfgvbtpztdggtodo54nme3755mq'

__PROD_CONTROL_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaajg4p7xvr7cv2drq37xsgoblx6e64g5segkwth3e6jt2bekn26npa'
__PROD_CONTROL_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaajtwim5st254beg3m5lkzynb46oa72ihakbuj76i2go23etgkrzra'
__PROD_MANAGEMENT_PLANE_API_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaa5huej7mm3hyh36knr6v74gsl4kizv3uh7nk6c2qel4tjzut3tdnq'
__PROD_DATA_PLANE_WORKER_COMPARTMENT = 'ocid1.compartment.oc1..aaaaaaaaumetikbza2x6b7gdyozenrqy2u5wymr64pdp5tft6ntxusrg2ela'

prodRegionMap = {
    "ashburn" : "iad",
    "phoenix" : "phx",
    "london" : "lhr",
    "frankfurt" :"fra"
}

def __check_package(pkg, pippkg = None):
    pippkg = pkg if pippkg == None else pippkg
    try:
        __import__(pkg)
    except ImportError as e:
        sys.stdout.write('{0} python package not available\n'.format(pkg))
        sys.stdout.write("Install by executing:\n")
        sys.stdout.write("  curl -O https://bootstrap.pypa.io/get-pip.py\n")
        sys.stdout.write("  env PIP_REQUIRE_VIRTUALENV=false sudo -E -H python get-pip.py\n")
        sys.stdout.write("  env PIP_REQUIRE_VIRTUALENV=false pip install --user {0}\n".format(pippkg))
        sys.stdout.flush()
        sys.exit(1)

def __check_packages():
    __check_package('oci')
    __check_package('requests')

def __get_instances(compartment_ids = None, region = None, jump_host = None):
    import oci
    config = oci.config.from_file("~/.oci/config", 'dlcdev-boat')
    compute = oci.core.ComputeClient(config)
    vcn = oci.core.VirtualNetworkClient(config)
    for compartment_id in compartment_ids:
        instances = oci.pagination.list_call_get_all_results(
                compute.list_instances,
                compartment_id = compartment_id,
                lifecycle_state = "RUNNING"
                )
        for instance in sorted(instances.data, key = lambda i: i.display_name):
            vnic_attachments = oci.pagination.list_call_get_all_results(
                    compute.list_vnic_attachments,
                    compartment_id = compartment_id,
                    instance_id = instance.id
                    )
            vnics = [vcn.get_vnic(va.vnic_id).data for va in vnic_attachments.data]
            private_ips_for_vnic = oci.pagination.list_call_get_all_results(
                vcn.list_private_ips,
                vnic_id=vnics[0].id
            ).data
            # print(repr(instance))
            print("Host {0}.{1}".format(instance.display_name.split("-", 2)[2], region)) 
            print("  HostName {0}".format(private_ips_for_vnic[0].ip_address))
            print("  ProxyJump {0}".format(jump_host))


# $HOME/.oci/conf
# [dlcdev-boat]
# user = ocid1.user.oc1.... # BOAT user ocid
# fingerprint = ...
# key_file = ...
# tenancy = ocid1.tenancy.oc1..aaaaaaaagkbzgg6lpzrf47xzy4rjoxg4de6ncfiq2rncmjiujvy2hjgxvziq # BOAT tenancy
# region = us-ashburn-1

def main(argv):
    __check_packages()
    parser = argparse.ArgumentParser(description='Generate ssh config hosts')
    parser.add_argument('environment', metavar='<environment>', help='Environment',
            choices=['DEV', 'PREPROD','PROD'])
    parser.add_argument('region', metavar='<region>', help='Region',
            choices=[
                    "ashburn",
                    "phoenix", "london", "frankfurt",
##REGION_LIST_ADD_ABOVE
            ])

    args = parser.parse_args()
    region = args.region.lower()

    if args.environment == 'DEV':
        if args.region == 'phoenix':
            jump_host = 'dlcdep-beta-jump.phx'
            compartments = [__DEV_CONTROL_PLANE_API_COMPARTMENT, __DEV_CONTROL_PLANE_WORKER_COMPARTMENT, __DEV_MANAGEMENT_PLANE_API_COMPARTMENT, __DEV_DATA_PLANE_WORKER_COMPARTMENT]
            region = 'phx'
        elif args.region == 'ashburn':
            jump_host = 'dlcdep-beta-jump.iad'
            compartments = [__DEV_CONTROL_PLANE_API_COMPARTMENT, __DEV_CONTROL_PLANE_WORKER_COMPARTMENT, __DEV_MANAGEMENT_PLANE_API_COMPARTMENT, __DEV_DATA_PLANE_WORKER_COMPARTMENT]
            region = 'iad'
    elif args.environment == 'PREPROD':
        compartments = [__PREPROD_CONTROL_PLANE_API_COMPARTMENT, __PREPROD_CONTROL_PLANE_WORKER_COMPARTMENT, __PREPROD_MANAGEMENT_PLANE_API_COMPARTMENT,__PREPROD_DATA_PLANE_WORKER_COMPARTMENT]
        if args.region == 'ashburn':
            jump_host = 'dlcdep-preprod-jump.iad'
            region = 'iad'
    elif args.environment == 'PROD':
        compartments = [__PROD_CONTROL_PLANE_API_COMPARTMENT, __PROD_CONTROL_PLANE_WORKER_COMPARTMENT, __PROD_MANAGEMENT_PLANE_API_COMPARTMENT,__PROD_DATA_PLANE_WORKER_COMPARTMENT]
        jump_host = 'dlcdep-prod-jump.'+prodRegionMap[args.region]
        region = prodRegionMap[args.region]
##ELIF_REGION_ADD_ABOVE
    else:
        sys.exit(1)

    __get_instances(compartment_ids = compartments, region = region, jump_host = jump_host)

if __name__ == '__main__':
    main(sys.argv)