# Copyright (c) 2017-present Sonatype, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

nexus=http://localhost/nexus

until curl --fail --insecure $nexus ; do 
  sleep 1
done

curl -u admin:admin123 --insecure --header 'Content-Type: application/json' "$nexus/service/siesta/rest/v1/script" -d @nexus-config/create-docker-proxy.json
curl -X POST -u admin:admin123 --insecure --header 'Content-Type: text/plain' "$nexus/service/siesta/rest/v1/script/CreateDockerProxy/run"
curl -X DELETE -u admin:admin123 --insecure --header 'Content-Type: text/plain' "$nexus/service/siesta/rest/v1/script/CreateDockerProxy"
curl -v -u admin:admin123 --insecure --header 'Content-Type: application/json' "$nexus/service/siesta/rest/v1/script" -d @nexus-config/create-docker-hosted.json
curl -v -X POST -u admin:admin123 --insecure --header 'Content-Type: text/plain' "$nexus/service/siesta/rest/v1/script/CreateDockerHosted/run"
