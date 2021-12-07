#!/bin/bash

# declare an image name
IMG_NAME=hello-openvino

IMG_FROM=${IMG_NAME}:non-tee
IMG_TO=${IMG_NAME}:tee

# build the regular non-TEE image
docker build . -t ${IMG_FROM}

# run the sconifier to build the TEE image based on the non-TEE image
docker run -it --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            registry.scontain.com:5050/sconecuratedimages/iexec-sconify-image:5.6.0-glibc \
            sconify_iexec \
            --base=ubuntu:20.04 \
            --name=${IMG_NAME} \
            --from=${IMG_FROM} \
            --to=${IMG_TO} \
            --binary-fs \
            --fs-dir=/app \
            --host-path=/etc/hosts \
            --host-path=/etc/resolv.conf \
            --volume=/iexec_out:/iexec_out \
            --volume=/iexec_in:/iexec_in \
            --binary=/root/miniconda/bin/python3.7 \
            --fs-file=/root/miniconda/lib/libpython3.7m.so.1.0 \
            --fs-file=/root/miniconda/lib/libinference_engine.so \
            --fs-file=/root/miniconda/lib/libtbb.so.2 \
            --fs-file=/root/miniconda/lib/libinference_engine_transformations.so \
            --fs-file=/root/miniconda/lib/libngraph.so \
            --fs-file=/root/miniconda/lib/libmkl_rt.so.1 \
            --fs-file=/root/miniconda/lib/libmkl_core.so.1 \
            --fs-file=/root/miniconda/lib/libmkl_intel_thread.so.1 \
            --fs-file=/root/miniconda/lib/libmkl_intel_lp64.so.1 \
            --fs-file=/root/miniconda/lib/libmkl_def.so.1 \
            --fs-file=/root/miniconda/lib/plugins.xml \
            --heap=1G \
            --dlopen=1 \
            --no-color \
            --verbose \
            --debug \
            --log=trace \
            && echo -e "\n------------------\n" \
            && echo "successfully built TEE docker image => ${IMG_TO}" \
            && echo "application mrenclave.fingerprint is $(docker run -it --rm -e SCONE_HASH=1 ${IMG_TO})"
