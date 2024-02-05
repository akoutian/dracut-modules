# dracut-modules
Custom dracut modules.

They are mainly relevant in a very particular context: a heavily modified
Thinkpad T420.

Flashing coreboot (https://www.coreboot.org/) is popular in these models; it
can unlock fantastic potential for upgrades and modifications, leading to
greatly increased performance.

However, such heavy modifications sometimes come with caveats, bugs, or
tradeoffs. These modules are meant to fix, work around and adjust for such
cases.

The modules are arbitrarily assigned a priority number of 94.

# installation
    cp -r modules/* /usr/lib/dracut/modules.d
