# fixtures = {}
# [
#   's3_bucket_name',
# ].each do |fixture_name|
#   fixtures[fixture_name] = attribute(
#     fixture_name,
#     default: "default.#{fixture_name}",
#     description: 'See ../build/s3.tf',
#   )
# end

control "s3-buckets-no-public-access" do
  impact 0.7
  title "Ensure there are no publicly accessible S3 buckets"
  desc "Ensure there are no publicly accessible S3 buckets"

  tag "nist": ["AC-6", "Rev_4"]
  tag "severity": "high"

  tag "check": "Review your AWS console and note if any S3 buckets are set to
                'Public'. If any buckets are listed as 'Public', then this is
                a finding."

  tag "fix": "Log into your AWS console and select the S3 buckets section. Select
              the buckets found in your review. Select the permisssions tab for
              the bucket and remove the Public access permission."

  describe aws_s3_buckets do
    it { should_not have_public_buckets }
  end

  describe aws_s3_buckets.where(availability: 'Public') do
    its('bucket_names') { should eq [] }
  end
end
