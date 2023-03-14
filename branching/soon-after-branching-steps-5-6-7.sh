# steps 5,6, and 7 of https://docs.google.com/document/d/1Z6ejnDCOCvNv9PWkyNPzVbjuLbDMAAT5GEeDpzb0SMs/edit#

# My notes:
# jq is a tool for working w JSON
# jq is also a command for working with JSON file like searching in it, editing, etc
# jq -r .status.tags[].tag => result of .status.tags[].tag will be written directly to standard output
#     https://linuxcommandlibrary.com/man/jq

# oc get <resource> -n <namespace> =>  get all resources in <namespace>

# oc get is 4.14 -n ocp -o json, get an ImageStream with the name 4.14 in the ocp namespace, 
#  -o json: specifies the output format as JSON

# oc tag ocp/4.14:$tag ocp/4.15:$tag =>
#   this will create a new tag ocp/4.15:$tag for the image that was
#   previously tagged as ocp/4.14:$tag


# Execute against app.ci (--context=app.ci)
for tag in $( oc get is 4.14 -n ocp -o json | jq -r .status.tags[].tag )
do
    oc tag ocp/4.14:$tag ocp/4.15:$tag --as system:admin
done


# Repeat the process for origin namespaces:
for tag in $( oc get is 4.14 -n origin -o json | jq -r .status.tags[].tag )
do
    oc tag origin/4.14:$tag origin/4.15:$tag --as system:admin
done


# Repeat the process for ocp-private namespace:
for tag in $( oc get is 4.14-priv -n ocp-private -o json | jq -r .status.tags[].tag )
do
    oc tag ocp-private/4.14-priv:$tag ocp-private/4.15-priv:$tag --as system:admin
done

