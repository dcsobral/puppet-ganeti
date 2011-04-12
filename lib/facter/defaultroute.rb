# defaultroute.rb

Facter.add("defaultroute") do
        setcode do
                %x{/sbin/route -n} =~ /^0.0.0.0\s+([\d.]+)/
                $1
        end
end

