#!/bin/bash

PROJECT_ID=("mitsui-id-core-defaroyan" "mitsui-id-network-defaroyan" "mitsui-jp-network-defaroyan") 

for element in "${PROJECT_ID[@]}"
do 
    echo "$element"
    sleep 2
    gcloud config set project ${element}
    sleep 2
    gcloud iam service-accounts create terraform-sa \
    --display-name="terraform-sa" \
    --project=${element}
    sleep 2
    gcloud projects add-iam-policy-binding ${element} \
    --member="serviceAccount:terraform-sa@${element}.iam.gserviceaccount.com" \
    --role="roles/editor"
    sleep 2
    gcloud iam service-accounts keys create terraform-key-${element}.json \
    --iam-account=terraform-sa@${element}.iam.gserviceaccount.com \
    --project=${element}
done