module load plink2
plink --file test --make-bed
plink --bfile plink --score test_score.raw sum --set test.set --gene red --out red_test
plink --bfile plink --score test_score.raw sum --set test.set --gene blue --out blue_test
plink --bfile plink --score test_score.raw sum --set test.set --gene green --out green_test
plink --bfile plink --score test_score.raw sum --set test.set --gene orange --out orange_test
