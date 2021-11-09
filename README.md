# 构建aws基础环境的terraform模板v3
GitHub地址: [https://github.com/hosinokoe/aws_tf_v3](https://github.com/hosinokoe/aws_tf_v3)

## 介绍
[Terraform](https://www.terraform.io/)是一个 IT 基础架构自动化编排工具。通过代码来编排基础机构，支持上百种云服务器，几乎包揽了市面上的所有云服务商。

## aws_tf_v3
该项目通过`terraform`来构建aws基础架构，使用共通代码来提高代码的简洁跟复用。

## aws的一些注意事项
1. 使用最新的ami做参数时，是一个会变化的值，在部署好架构后，根据项目需要写死
2. ebs使用固定参数部署后snapshot_id是固定的，但是部署后需要写死，否则再次部署会重建，可在共通代码里写成参数，部署后在项目参数中写死
3. subnet_id不能指定null
4. 安全组的规则不能同时使用两种写法，会互相覆盖
5. iam policy里面${}变量需要写成$${}，跟terraform的语法冲突了。
6. 安全组最好使用lifecycle，create before destroy，否则无法替换。
7. rds如果使用multi-az，那么不能指定可用区。也即是AvailabilityZone在MultiAZ为true时，不能使用。
8. rds的dbname不能使用-，但可以使用_
9. elb name不能使用_，但可以使用-
10. rds Performance Insights不支持t3.small及以下的实例
11. cloudfront里的DefaultCacheBehavior->TargetOriginId必须跟Origins->Id一致