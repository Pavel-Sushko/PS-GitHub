function github
{
    $i = 1
    [string]$username = "Pavel-Sushko"

    [Parameter (Mandatory=$false)] [string]$asignee
    [Parameter (Mandatory=$false)] [string]$reviewer
    [Parameter (Mandatory=$false)] [bool]$m

    if ($PSBoundParameters.ContainsKey('asignee'))
    {    }
    else
    {
        $asignee = $username
    }

    if($PSBoundParameters.ContainsKey('reviewer'))
    {    }
    else
    {
        $reviewer = $username
    }

    do
    {
        [string]$branch = "$username-patch-$i"
        [string]$checkStr = $(git branch $branch 2>&1)

        if ($checkStr -eq "fatal: A branch named '$branch' already exists.")
        {
            $check = $false
        }
        else
        {
            $check = $true

            git branch "$branch"
        }

        $i++
    }
    while (-Not $check)

    git checkout $branch

    git commit -a

    git push --all --progress

    gh pr create -f -a $asignee -r $reviewer

    if ($m -imatch 'y')
    {
        gh pr merge $branch
    }

    gh pr diff $branch
}