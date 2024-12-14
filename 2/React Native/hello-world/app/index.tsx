import { ScrollView, Image, Text, View, Button, StyleSheet } from "react-native";
import Title from "@/components/Title";
import SuperButton from "@/components/SuperButton";

export default function Index() {

  const showMessage = ()=>{
    alert("Minha Mensagem")
  }

  return (
    <ScrollView>
      <View style={styles.container}>
        <Image 
        style={styles.image}
        source={{
          uri: "https://s3.wasabisys.com/instax/74/instax/2023/03/foto-de-por-do-sol-1678156462.jpeg"
        }}>
        </Image>

        <Image
        style={styles.image}
        source={require("@/assets/images/react-logo.png")}>
        </Image>

        <Title name="Super Titulo1" upperCase={false}></Title>    
        <Title name="Super Titulo2" upperCase={true}></Title>    
        <Title name="Super Titulo2" upperCase></Title>    
 

        <Text style={styles.title}>Hello World</Text>
        <Button title="Clica Aqui" onPress={showMessage}></Button>

        <SuperButton title="Mostrar Mensagem" OnPress={showMessage}/>
        <SuperButton title="Teste" icon="add-circle " OnPress={showMessage}/>

      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  image:{
    width: 100,
    height: 100,
    backgroundColor: "white"
  },
  container:{
    flex: 1,
    justifyContent: "center",
    backgroundColor: "yellow",
    alignItems: "center",
  },
  title:{
    fontWeight: "bold",
    fontSize: 28,
    color: "#F00" //RED
  }
})