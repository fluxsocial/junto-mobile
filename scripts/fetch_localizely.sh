curl -X GET "https://api.localizely.com/v1/projects/8a7cdfd2-aaef-4e44-a773-9c9801bf1c69/files/download?type=flutter_arb" -H "accept: */*" -H "X-Api-Token: 881c821a99c64f95867d47f568273f2f7a4be5bb17934b63a116e73fd8e127cc" --output /tmp/lang.zip
unzip -o /tmp/lang.zip -d ./lib/l10n/
rm /tmp/lang.zip