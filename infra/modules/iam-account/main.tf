###########################################
### Source IP Restriction               ###
###########################################
data "aws_iam_policy_document" "source_ip_restriction" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = ["106.72.152.1"]
    }
  }
}

resource "aws_iam_policy" "source_ip_restriction" {
  name        = "SourceIpRestrictionPolicy"
  policy      = data.aws_iam_policy_document.source_ip_restriction.json
}


###########################################
### Allow Own MFA                       ###
###########################################
data "aws_iam_policy_document" "allow_own_mfa" {
  statement {
    effect    = "Allow"
    actions   = ["iam:ListVirtualMFADevices"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "iam:CreateVirtualMFADevice",
      "iam:DeleteVirtualMFADevice"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:mfa/$${aws:username}"]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:mfa/$${aws:username}"]
  }

  statement {
    effect    = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "iam:ChangePassword",
      "sts:GetSessionToken"
    ]
    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "allow_own_mfa" {
  name        = "AllowOwnMfa"
  policy      = data.aws_iam_policy_document.allow_own_mfa.json
}


###########################################
### Assume Role For DevOps              ###
###########################################
data "aws_iam_policy_document" "assume_role_for_devops" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/DevOps"]
  }
}

resource "aws_iam_policy" "assume_role_for_devops" {
  name   = "AssumeRoleForDevOps"
  policy = data.aws_iam_policy_document.assume_role_for_devops.json
}


###########################################
### Allow Change Own Password           ###
###########################################
data "aws_iam_policy_document" "allow_change_own_password" {
  statement {
    effect    = "Allow"
    actions   = ["iam:GetAccountPasswordPolicy"]
    resources = ["*"]
  }

  statement {
    sid       = "ChangeOwnPassword"
    effect    = "Allow"
    actions   = [
      "iam:GetUser",
      "iam:ChangePassword"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/$${aws:username}"]
  }
}

resource "aws_iam_policy" "allow_change_own_password" {
  name   = "AllowChangeOwnPassword"
  policy = data.aws_iam_policy_document.allow_change_own_password.json
}

###########################################
### Allow Assume Role To DevOps        ###
###########################################
data "aws_iam_policy_document" "allow_assume_role_to_devops" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/DevOps"]
  }
}

resource "aws_iam_policy" "allow_assume_role_to_devops" {
  name   = "AllowAssumeRoleToDevops"
  policy = data.aws_iam_policy_document.allow_assume_role_to_devops.json
}

###########################################
### NoAuthorizedGroup                   ###
###########################################
resource "aws_iam_group" "no_authorized_group" {
  name = "NoAuthorizedGroup"
}

resource "aws_iam_group_policy_attachment" "no_authorized_group_1" {
  group      = aws_iam_group.no_authorized_group.name
  policy_arn = aws_iam_policy.source_ip_restriction.arn
}

resource "aws_iam_group_policy_attachment" "no_authorized_group_2" {
  group      = aws_iam_group.no_authorized_group.name
  policy_arn = aws_iam_policy.allow_own_mfa.arn
}

resource "aws_iam_group_policy_attachment" "no_authorized_group_3" {
  group      = aws_iam_group.no_authorized_group.name
  policy_arn = aws_iam_policy.allow_change_own_password.arn
}

resource "aws_iam_group_policy_attachment" "no_authorized_group_4" {
  group      = aws_iam_group.no_authorized_group.name
  policy_arn = aws_iam_policy.allow_assume_role_to_devops.arn
}

###########################################
### DevOps Role                         ###
###########################################
data "aws_iam_policy_document" "assume_role_devops_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/tamura"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:RoleSessionName"
      values   = ["$${aws:username}"]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "devops" {
  name                = "DevOps"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_devops_trust.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}