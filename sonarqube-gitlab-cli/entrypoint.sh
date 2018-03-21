#!/bin/sh

COMMON_PARAMS="-X -Dsonar.sources=. -Dsonar.host.url=${URL} -Dsonar.projectKey=${PROJECT_KEY} -Dsonar.projectName=${PROJECT_NAME}  -Dsonar.login=${USER} -Dsonar.password=${PASSWORD}"

if [ "${MAIN_BRANCH}" = "${CI_BUILD_REF_NAME}" ]
then
	sonar-scanner ${COMMON_PARAMS} -Dsonar.projectVersion=${VERSION} ${CUSTOM_PARAMS}
else
	sonar-scanner ${COMMON_PARAMS} -Dsonar.projectVersion=${VERSION} -Dsonar.analysis.mode=preview -Dsonar.gitlab.commit_sha=${CI_BUILD_REF} -Dsonar.gitlab.ref_name=${CI_BUILD_REF_NAME} -Dsonar.gitlab.project_id=${CI_PROJECT_ID} ${CUSTOM_PARAMS}
fi

chown -R ${UID}:${GID} /build
