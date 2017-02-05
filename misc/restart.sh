#!/bin/bash

systemctl daemon-reload
systemctl restart tiotests.timer
systemctl restart tiotestsnz.timer
systemctl restart frontail.service
systemctl restart frontailnz.service
