1 variable "environment" { 
2   description = "Environment to use: nonprod, prod" 
3   type        = "string" 
4 } 
5 
 
6 variable "workspace" { 
7   description = "Name of the workspace ie. oea" 
8 } 
9 
 
10 variable "resource_group_tags" { 
11   description = "Map of tags to apply to the resource group" 
12   type        = "map" 
13   default     = {} 
14 } 
15 
 
16 variable "arm_location" { 
17   description = "Azure location region to provision the resource" 
18   default     = "eastus" 
19 } 
20 
 
21 variable "global_tags" { 
22   description = "Map of tags to apply to all resources that have tags parameters" 
23   type        = "map" 
24   default     = {} 
25 } 
26 
 
27 // Virtual Network 
28 
 
29 variable "vnet_name" { 
30   type        = "string" 
31   description = "Name of the virtual network" 
32   default     = "vnet" 
33 } 
34 
 
35 // Network Security Group variables 
36 variable "nsg_name" { 
37   type        = "string" 
38   description = "Name of the network security group" 
39   default     = "nsg" 
40 } 
41 
 
42 variable "nsg_tags" { 
43   type        = "map" 
44   description = "Tags for the network security group" 
45   default     = {} 
46 } 
47 
 
48 variable "pricing_tier" { 
49   type        = "string" 
50   default     = "premium" 
51   description = "The pricing tier of workspace." 
52 } 
53 
 
54 variable "existing_rg_name" { 
55   type        = "string" 
56   default     = "" 
57   description = "Existing resource group to add all workspace resources into" 
58 } 
59 
 
60 variable "os_linux" { 
61   default     = true 
62   description = "Is linux os" 
63 } 
64 
 
65 variable "non_prod_common_subscription_id" { 
66   type        = "string" 
67   description = "Subscription id for non-prod common global subscription" 
68   default     = "18e83779-fedb-4248-8137-9e040eaabf29" 
69 } 
70 
 
71 variable "prod_common_subscription_id" { 
72   type        = "string" 
73   description = "Subscription id for prod common global subscription" 
74   default     = "cc803b56-bf16-4400-b769-3502c564cefb" 
75 } 
