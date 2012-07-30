def prompt_and_get(promp)
    print promp
    res = readline.chomp
    throw :quit_request if res == "!"
    res
end

catch :quit_request do
    name = prompt_and_get("Name: ")
    age = prompt_and_get("Age: ")
    sex = prompt_and_get("sex: ")
end
