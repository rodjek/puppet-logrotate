# This fact creates a random int based off the IP address of the host
# Can be used for randomising cronjobs
#
Facter.add("randminute") do
        setcode do
                Facter::ipaddress.gsub(/\./,'').to_i%30
        end
end

Facter.add("randhour") do
        setcode do
                Facter::ipaddress.gsub(/\./,'').to_i%12
        end
end

# Random Hour between 0800 and 1800
Facter.add("randworkhour") do
        setcode do
                (Facter::ipaddress.gsub(/\./,'').to_i%12) + 8
        end
end
