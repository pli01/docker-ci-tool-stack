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

nexus=${nexus:-http://nexus/nexus}
prefix=$(dirname $0)
echo "Wait $nexus ready ?"
until curl --fail --insecure $nexus ; do 
  sleep 1
done

echo "Start config for $nexus"
for file in $prefix/nexus-config/*.json ; do
  task=$(basename $file .json)
  $prefix/nexus/delete.sh $task
  $prefix/nexus/create.sh $file
  $prefix/nexus/run.sh $task
  $prefix/nexus/delete.sh $task
done
echo "End config for $nexus"
