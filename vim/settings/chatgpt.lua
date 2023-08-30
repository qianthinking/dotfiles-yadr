require("codegpt.config")

vim.g["codegpt_commands"] = {
    ["completion"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code snippet: ```{{filetype}}\n{{text_selection}}```\nPlease complete the rest. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["qc"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code snippet: ```{{filetype}}\n{{text_selection}}```\nPlease complete the rest. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-3.5-turbo",
        max_tokens = 4096,
        temperature = 0,
    },
    ["qr"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code snippet: ```{{filetype}}\n{{text_selection}}```\nPlease refactor the code. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-3.5-turbo",
        max_tokens = 4096,
        temperature = 0,
    },
    ["r"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code snippet: ```{{filetype}}\n{{text_selection}}```\nPlease refactor the code. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["code_edit"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\n{{command_args}}. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["explain"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nExplain the following {{language}} code: ```{{filetype}}\n{{text_selection}}``` Explain as if you were explaining to another developer.",
        callback_type = "text_popup",
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["question"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have a question about the following {{language}} code: ```{{filetype}}\n{{text_selection}}``` {{command_args}}",
        callback_type = "text_popup",
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["debug"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nAnalyze the following {{language}} code for bugs: ```{{filetype}}\n{{text_selection}}```",
        callback_type = "text_popup",
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["doc"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nWrite really good documentation using best practices for the given language. Attention paid to documenting parameters, return types, any exceptions or errors. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["opt"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nOptimize this code. {{language_instructions}} Only return the code snippet and nothing else.",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["tests"] = {
        user_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.\nI have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nWrite really good unit tests using best practices for the given language. {{language_instructions}} Only return the unit tests. Only return the code snippet and nothing else. ",
        callback_type = "code_popup",
        language_instructions = {
        },
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
    ["chat"] = {
        system_message_template = "You need to play the role of an experienced full-stack software engineering expert. You have a deep understanding of Machine Learning, Deep Learning, MLOps, Software Architect/Design/Development, DevOps and are proficient in programming languages such as Python, React.js, Java, Shell. You strive for best practices and excel at writing high-quality code.",
        user_message_template = "{{command_args}}",
        callback_type = "text_popup",
        model = "gpt-4",
        max_tokens = 8192,
        temperature = 0,
    },
}
vim.keymap.set({ 'v' }, '<C-g>', [[<Cmd>'<,'>Chat<CR>]], { noremap = true })

