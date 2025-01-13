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
		autostart = false;
		address = [ "10.7.0.2/24" ];
		listenPort = 51820;
		privateKeyFile = "/etc/nixos/keys/sib_key";
		dns = [ "1.1.1.1" ];	
		peers = [{
			publicKey = "UvFo3/tfEdi0VZ73mEoOS8Ka499XVB0LpagHlDgE1S4=";
			presharedKeyFile = "/etc/nixos/keys/presib_key";
			allowedIPs = [ "0.0.0.0/0" "::/0" ];
			endpoint = "vpn.salverdaserver.nl:51820";
			persistentKeepalive = 25;
		}];
	};
	Emmeloord = {
		autostart = false;
		address = [ "10.7.0.3/24" "fddd:2c4:2c4::3/64" ];
		listenPort = 51820;
		privateKeyFile = "/etc/nixos/keys/emm_key";
		dns = [ "192.168.2.254" ];
		peers = [{
			publicKey = "DBvdtcit6+8wWn5J5sx4cmTI07IMni4gADrrzFFpnEg=";
			presharedKeyFile = "/etc/nixos/keys/preemm_key";
			allowedIPs = [ "0.0.0.0/0" "::/0" ];
			endpoint = "vpn2.salverdaserver.nl:51820";
			persistentKeepalive = 25;
		}];
		};
	};
}
