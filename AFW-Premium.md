## Exercice 8: Testing Azure Firewall's Premium features (TLS inspection) : 

Azure Firewall Premium provides advanced threat protection that meets the needs of highly sensitive and regulated environments, such as the payment and healthcare industries.
This is provided thanks to the following features:

**TLS inspection** - decrypts outbound traffic, processes the data, then encrypts the data and sends it to the destination.

**IDPS** - A network intrusion detection and prevention system (IDPS) allows you to monitor network activities for malicious activity, log information about this activity, report it, and optionally attempt to block it.

**URL filtering** - extends Azure Firewall’s FQDN filtering capability to consider an entire URL along with any additional path. For example, www.contoso.com/a/c instead of www.contoso.com.

**Web categories** - administrators can allow or deny user access to website categories such as gambling websites, social media websites, and others.

<img src="Images\afw-premium-overview.png" width="600"> 	

We are going to enable the Transport Layer Security (TLS) Inspection feature of Azure Firewall Premium by using the Certification **Auto-Generation** mechanism, which automatically creates the following three resources for you:

- Managed Identity
- Key Vault
- Self-signed Root CA certificate

### Task 1: Validate Azure Firewall DNS logs
`nslookup mydbserver1.database.windows.net`  
