import {generatorSorry} from "@/services/ai/generator";
import styles from "@/styles";
import {useState} from "react";
import {Text, TextInput, TouchableOpacity, View} from "react-native";
import {MotiView} from 'moti';
import { opacity } from "react-native-reanimated/lib/typescript/Colors";

export default function Index() {
  const [sorry, setSorry] = useState("")
  const [response, setResponse] = useState("")
  const [isLoading, setIsLoading] = useState(false)


  const generateSorry = async () => {
    if(sorry.length < 5){
      alert("Desculpe, o evento precisa ter mais de 5 caracteres")
      return
    }

    setIsLoading(true)
    setSorry("")
    setResponse("")

    try{
      const result = await generatorSorry(sorry);
      setResponse(result)
    }catch(error){
      alert(error)
    }finally{
      setIsLoading(false)
    }
  

  }

  return (
    <View
      style={styles.container}
    >
      <Text style = {styles.title}>Desculpator 3000</Text>
      <Text style = {styles.subtitle}>Sua maquina de desculpas profissional</Text>
      <TextInput
      onChangeText={setSorry}
      value = {sorry}
      style = {styles.input}
      placeholder="Digite o evento que você quer evitar..."></TextInput>

      <TouchableOpacity style = {styles.button} onPress = {generateSorry}>
        <Text style = {styles.buttonText}>{isLoading ? "Carregando..." : "Gerar desculpas infalível!"}</Text>
      </TouchableOpacity>

    {
      response && (
        <MotiView 
        style = {styles.card}
        from = {{opacity:0, translateY:200}}
        animate = {{opacity: 1, translateY: 0}}>
          <Text style = {styles.cardTitle}>Sua desculpa está pronta:</Text>
          <Text style = {styles.cardText}>{response}</Text>
        </MotiView>
      )
    }
    </View>
  );
}
