# acs-image-cve
Script which uses Red Hat Advanced Cluster Security integration to generate a CVS file that contains CVE vulnerability data for images in a specific or all namespaces in your cluster.

```
./images.sh my-namespace

We are in acstest looking at sha256:55228aae65073e129dc0b9485fcf1b00f73b980eea135fcfe1f079383e7895e3
"CVE","CVSS Score","Summary","Component","Version","Fixed By","Layer Index","Layer Instruction"
"CVE-2015-5186",4.3,"","audit-libs","2.8.5-4.el7.x86_64",,0,"RUN "
"CVE-2012-6711",7,"DOCUMENTATION: A heap-based buffer overflow was discovered in bash when wide characters, not supported by the current locale set in LC_CTYPE 
environment variable, are printed through the echo built-in function. A local attacker, who can provide data to print through the `echo -e` built-in function, m
ay use this flaw to crash a script or execute code with the privileges of the bash process.
            STATEMENT: Impact set to Moderate as the flaw requires the usage of `echo -e` built-in function with a string controlled by the attacker. Abusing th
is flaw would allow an attacker to, at most, execute code with the privileges of the bash process, which could be used e.g. to escape a restricted shell in case
 of a local attacker scenario or remotely execute code in case of a bash script that accepts untrusted input from the network. However we do not recommend to us
e bash scripts to handle untrusted data from the network.","bash","4.2.46-34.el7.x86_64",,0,"RUN "
"CVE-2019-18276",7.8,"DOCUMENTATION: A privilege escalation vulnerability was found in bash in the way it dropped privileges when started with an effective user
 id not equal to the real user id. Bash may be vulnerable to this flaw if the setuid permission is set and the owner of the bash program itself is a non-root us
er. A local attacker could exploit this flaw to escalate their privileges on the system.","bash","4.2.46-34.el7.x86_64",,0,"RUN "
"CVE-2014-9939",1.2,"STATEMENT: This issue affects the versions of binutils as shipped with Red Hat Enterprise Linux 5, 6, and 7. Red Hat Product Security has r
ated this issue as having Low security impact. For additional information, refer to the Issue Severity Classification: https://access.redhat.com/security/update
s/classification/.","binutils","2.27-44.base.el7.x86_64",,0,"RUN "
"CVE-2015-8538",1.7,"","binutils","2.27-44.base.el7.x86_64",,0,"RUN "
"CVE-2016-2226",3.3,"STATEMENT: Red Hat Product Security has rated this issue as having Low security impact. This issue is not currently planned to be addressed
 in future updates. For additional information, refer to the Issue Severity Classification: https://access.redhat.com/security/updates/classification/.","binuti
ls","2.27-44.base.el7.x86_64",,0,"RUN "
"CVE-2016-4487",5.3,"STATEMENT: Red Hat Product Security has rated this issue as having Low security impact. This issue is not currently planned to be addressed
 in future updates. For additional information, refer to the Issue Severity Classification: https://access.redhat.com/security/updates/classification/.","binuti
ls","2.27-44.base.el7.x86_64",,0,"RUN "
"CVE-2016-4488",5.3,"STATEMENT: Red Hat Product Security has rated this issue as having Low security impact. This issue is not currently planned to be addressed
 in future updates. For additional information, refer to the Issue Severity Classification: https://access.redhat.com/security/updates/classification/.","binuti
ls","2.27-44.base.el7.x86_64",,0,"RUN "
"CVE-2016-4489",5.9,"STATEMENT: Red Hat Product Security has rated this issue as having Low security impact. This issue is not currently planned to be addressed
 in future updates. For additional information, refer to the Issue Severity Classification: https://access.redhat.com/security/updates/classification/.","binuti
ls","2.27-44.base.el7.x86_64",,0,"RUN "

... and so on ...
```
