## Exercice 8: Testing Azure Firewall's Premium features: 

Azure Firewall Premium provides advanced threat protection that meets the needs of highly sensitive and regulated environments, such as the payment and healthcare industries.
This is provided thanks to the following features:

**TLS (Transport Layer Security) inspection** - decrypts outbound traffic, processes the data, then encrypts the data and sends it to the destination.

**IDPS** - A network intrusion detection and prevention system (IDPS) allows you to monitor network activities for malicious activity, log information about this activity, report it, and optionally attempt to block it.

**URL filtering** - extends Azure Firewall’s FQDN filtering capability to consider an entire URL along with any additional path. For example, www.contoso.com/a/c instead of www.contoso.com.

**Web categories** - administrators can allow or deny user access to website categories such as gambling websites, social media websites, and others.

<img src="Images\afw-premium-overview.png" width="600"> 	

We are going to enable the Transport Layer Security (TLS) Inspection feature of Azure Firewall Premium by using the Certification **Auto-Generation** mechanism, which automatically creates the following three resources for you:

- Managed Identity
- Key Vault
- Self-signed Root CA certificate

### Why TLS use inspection?

The TLS protocol primarily provides cryptography for **privacy, integrity, and authenticity** using certificates between two or more communicating applications. It runs in the application layer and is widely used to encrypt the **HTTP protocol**.

Encrypted traffic has a possible security risk and can hide illegal user activity and malicious traffic. Azure Firewall without TLS inspection has no visibility into the data that flows in the encrypted TLS tunnel, and so can't provide a full protection coverage: 

<img src="Images\afw-premium-without-TLS.png" width="600"> 	

Azure Firewall Premium terminates and inspects TLS connections to **detect, alert, and mitigate** malicious activity in HTTPS. 
The firewall actually creates two dedicated TLS connections: one with the Web Server (contoso.com) and another connection with the client. 
Using the customer provided CA certificate, it generates an **on-the-fly certificate**, which replaces the Web Server certificate and shares it with the client to establish the TLS connection between the firewall and the client.

<img src="Images\afw-premium-without-TLS.png" width="600"> 	

The following use cases are supported with Azure Firewall:
- Outbound TLS Inspection: To protect against malicious traffic that is sent from an internal client hosted in Azure to the Internet.
- East-West TLS Inspection (includes traffic that goes from/to an on-premises network):To protect your Azure workloads from potential malicious traffic sent from within Azure.
- Inbound TLS Inspection (Supported only by [Azure Web Application Firewall on Azure Application Gateway](https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview)): To protect internal servers or applications hosted in Azure from malicious requests that arrive from the Internet or an external network. Application Gateway provides end-to-end encryption.

<img src="Images\afw-AppGaw.png" width="600"> 	 
