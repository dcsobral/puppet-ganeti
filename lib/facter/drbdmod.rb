# drbdmod.rb

Facter.add("drbdmod") do
        setcode do
                %x{/sbin/modprobe -qn drbd && /bin/echo yes || /bin/echo no}.chomp
        end
end

