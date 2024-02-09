{
	pkgs,
	...
}:
{
	networking.firewall = {
		allowedUDPPorts = [ 51820 ]; #port for wireguard
	};
	networking.wireguard.enable = true;
	networking.firewall.checkReversePath = false;
	networking.wg-quick.interfaces = {
	Sibelius = {
	
		address = [ "10.7.0.2/24" ];
		listenPort = 51820;
		privateKeyFile = "/etc/nixos/keys/sib_key";
		dns = [ "192.168.0.125" ];	
		peers = [{
			publicKey = "UvFo3/tfEdi0VZ73mEoOS8Ka499XVB0LpagHlDgE1S4=";
			presharedKeyFile = "/etc/nixos/keys/presib_key";
			allowedIPs = [ "0.0.0.0/0" "::/0" ];
			endpoint = "vpn.salverdaserver.nl:51820";
			persistentKeepalive = 25;
		}];
	};
	};
}
