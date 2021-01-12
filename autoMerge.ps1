function github
{
    $i = 1
    [string]$username = "Pavel-Sushko"

    [Parameter (Mandatory=$false)] [string]$a
    [Parameter (Mandatory=$false)] [string]$r
    [Parameter (Mandatory=$false)] [string]$m

    if(-not($PSBoundParameters.ContainsKey('assignee')) -and $a)
    {
        $a = $username
    }

    if(-not($PSBoundParameters.ContainsKey('reviewer')) -and $r)
    {
        $r = $username
    }

    if(-not($PSBoundParameters.ContainsKey('merge')) -and $m)
    {
        $m = $false
    }
    else
    {
        $m = $true
    }

    do
    {
        [string]$checkStr = $(git "$username-patch-$i" 2>&1)

        echo "In loop iteration $i"
        echo "$a-patch-$i"

        if ($checkStr -eq "fatal: A branch named '$a-patch-$i' already exists.")
        {
            $check = $false
        }
        else
        {
            $check = $true

            [string]$branch = "$username-patch-$i"

            git branch $branch
        }

        $i++
    }
    while (-Not $check)

    git checkout $branch

    git commit -a

    git push --all --progress

    gh pr create -a $a -f -l $l

    if ($m)
    {
        gh pr merge $branch
    }

    gh pr diff $branch
}