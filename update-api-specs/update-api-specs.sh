#!/bin/bash
set -e

devops_service_spec_version=0.1.59

# DO NOT CHANGE THIS:
spec_dir="../shepherd/deploy-splat/api-specs"

echo Get api.yaml for spec-target-group=internal
mvn clean install -Dspec-target-group=internal -Ddevops-service-spec-version=$devops_service_spec_version -Dspec-dir=$spec_dir
if [ $? -ne 0 ]; then
  echo "ERROR: mvn build failed"
fi

set +e
head -1 ${spec_dir}/internal/api.yaml |grep "DO NOT EDIT"
if [ $? -ne 0 ]; then
  set -e
  echo "# GENERATED from com.oracle.pic.dlc:devops-service-java-client:${devops_service_spec_version} - DO NOT EDIT" > ${spec_dir}/internal/api.yaml.tmp
  cat ${spec_dir}/internal/api.yaml >> ${spec_dir}/internal/api.yaml.tmp
  mv ${spec_dir}/internal/api.yaml.tmp ${spec_dir}/internal/api.yaml
fi
echo

set -e
echo Get api.yaml for spec-target-group=release
mvn clean install -Dspec-target-group=release -Ddevops-service-spec-version=$devops_service_spec_version -Dspec-dir=$spec_dir
if [ $? -ne 0 ]; then
  echo "ERROR: mvn build failed"
fi

set +e
head -1 ${spec_dir}/release/api.yaml |grep "DO NOT EDIT"
if [ $? -ne 0 ]; then
  set -e
  echo "# GENERATED from com.oracle.pic.dlc:devops-service-java-client:${devops_service_spec_version} - DO NOT EDIT" > ${spec_dir}/release/api.yaml.tmp
  cat ${spec_dir}/release/api.yaml >> ${spec_dir}/release/api.yaml.tmp
  mv ${spec_dir}/release/api.yaml.tmp ${spec_dir}/release/api.yaml
fi
echo

git status

