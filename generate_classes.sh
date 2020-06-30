echo 'Removing all resources in folder Resources'
rm -fR Resources

echo 'Creating Colors folder'
mkdir -p Resources/Colors

echo 'Check config swiftgen.yml and run'
swiftgen config lint && swiftgen config run --verbose