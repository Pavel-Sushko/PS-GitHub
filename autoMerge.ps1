function github
{
    $i = 1
    [string]$username = "Pavel-Sushko"

    [Parameter (Mandatory=$false)] [string]$asignee
    [Parameter (Mandatory=$false)] [string]$reviewer
    [Parameter (Mandatory=$false)] [string]$merge

    if(-not($PSBoundParameters.ContainsKey('assignee')) -and $a)
    {
        $asignee = $username
    }

    if(-not($PSBoundParameters.ContainsKey('reviewer')) -and $reviewer)
    {
        $reviewer = $username
    }

    if(-not($PSBoundParameters.ContainsKey('merge')) -and $merge)
    {
        $merge = $false
    }
    else
    {
        $merge = $true
    }

    do
    {
        [string]$checkStr = $(git "$asignee-patch-$i" 2>&1)

        [string]$branch = "$asignee-patch-$i"

        if ($checkStr -eq "fatal: A branch named '$branch' already exists.")
        {
            $check = $false
        }
        else
        {
            $check = $true

            git branch $branch
        }

        $i++
    }
    while (-Not $check)

    git checkout $branch

    git commit -a

    git push --all --progress

    gh pr create -f -a $asignee -r $reviewer

    if ($m)
    {
        gh pr merge $branch
    }

    gh pr diff $branch
}