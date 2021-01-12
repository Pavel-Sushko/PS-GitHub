﻿function github
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
        [string]$checkStr = $(git "$username-patch-$i" 2>&1)

        [string]$branch = "$username-patch-$i"

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

    if ($PSBoundParameters.ContainsKey('m'))
    {
        echo 'Good'

        gh pr merge $branch
    }

    # cls

    gh pr diff $branch
}