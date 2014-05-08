x = ["5", "7"]

fun x = foldl aux [] x
    where aux acc x = do let n = read x :: Int
                         n : acc

a = ["*   *","*   *"," * l","  *"," * *","*   *","*   *"]

check fs = and $ map and $ map (map aux) fs
    where aux c = if c == '*'
                    then True
                    else if c == ' '
                            then True
                            else False

check1 fs num = and $ map toBool fs
    where toBool s = if (length s) == num then True
                                     else False

