const Groq = require('groq-sdk');

const groq = new Groq({ apiKey: process.env.EXPO_PUBLIC_GROQ_KEY });

export async function generatorSorry(sorry: string) {
    try {
        const chatCompletion = await groq.chat.completions.create({
            "messages": [
                {
                    "role": "user",
                    "content": "Estou fazendo um app onde o usuário entrará com um evento e quero responder com uma desculpa esfarrapada, quero que seja engraçada e que não ofenda ninguém, mas seja criativo."
                },
                {
                    "role": "assistant",
                    "content": "Eu entendo! Vou ajudar você a criar uma lista de desculpas esfarrapadas engraçadas e criativas para o seu app. Aqui vão algumas sugestões:\n\n1. **Evento:** Jantar com amigos\n**Desculpa:** \" Desculpe, não posso ir. Estou com uma crise de falta de habilidades culinárias e não quero que meus amigos morram de fome ou envenenados.\"\n2. **Evento:** Festa de aniversário\n**Desculpa:** \"Infelizmente, não posso comparecer. Estou com um compromisso anterior com meu sofá e não posso abandoná-lo.\"\n3. **Evento:** Reunião de trabalho\n**Desculpa:** \"Desculpe, não posso ir. Estou com uma doença rara chamada 'sindromeda' e o meu médico disse que preciso ficar em casa e assistir vídeos de gatinhos para me curar.\"\n4. **Evento:** Encontro com amigos\n**Desculpa:** \"Não posso ir, estou com uma missão secreta para encontrar o último pacote de biscoitos que meu irmão escondeu em nossa casa. É uma questão de segurança nacional.\"\n5. **Evento:** Festival de música\n**Desculpa:** \"Desculpe, não posso ir. Estou com um problema técnico em meu aparelho auditivo e preciso ir ao hospital para que eles troquem minhas trompas de ouvido por umas novas, mais resistentes.\"\n6. **Evento:** Evento esportivo\n**Desculpa:** \"Não posso ir, estou com uma lesão grave em meu dedo mindinho e não quero arriscar perder a Copa Mundial de... vídeo game.\"\n7. **Evento:** Noite de cinema\n**Desculpa:** \"Desculpe, não posso ir. Estou com uma crise de falta de inspiração para fazer pipoca e não quero perder meu título de 'Pipocador Mundial'.\"\n\nEssas são apenas algumas ideias para você começar a criar seu app. Lembre-se de que o importante é ser criativo e engraçado sem ofender ninguém. Boa sorte!"
                },
                {
                    "role": "user",
                    "content": "Quero te enviar o evento e você irá me responder somente a desculpa"
                },
                {
                    "role": "assistant",
                    "content": " Envie o evento!"
                },
                {
                    "role": "user",
                    "content": "ir para uma festa de casamento"
                },
                {
                    "role": "assistant",
                    "content": "\"Desculpe, não posso ir. Estou com uma doença rara chamada 'Fobia de Dança de Festa' e meu médico disse que preciso ficar longe de qualquer local com música e pessoas felizes.\""
                },
                {
                    "role": "user",
                    "content": sorry
                },
            ],
            "model": "llama-3.1-70b-versatile",
            "temperature": 1,
            "max_tokens": 1024,
            "top_p": 1,
        });
        return chatCompletion.choices[0]?.message?.content;
    } catch (error) {
        return "Preciso ajudar minha vovó a hackear a NASA"
    }

}