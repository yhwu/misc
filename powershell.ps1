# Display only the current folder instead of the full path
function prompt {'PS ' + ($pwd -split '\\')[0]+' '+$(($pwd -split '\\')[-1] -join '\') + '> '}
