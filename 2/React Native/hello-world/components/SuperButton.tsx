import {TouchableOpacity, Text, StyleSheet} from 'react-native'
import Ionicons from '@expo/vector-icons/Ionicons'

interface ISuperButton {
    title: string,
    icon?: keyof typeof Ionicons.glyphMap,
    OnPress: () => void
}

const SuperButton = (props: ISuperButton) => {
    const {title, icon, OnPress} = props;
     return(
        <TouchableOpacity style = {style.container} onPress={OnPress}>
            {icon && <Ionicons name = {icon} size = {32} color = "white"/>}
            <Text style = {style.text}>{title}</Text>
        </TouchableOpacity>
     )
}

const style = StyleSheet.create({ 
    container:{
        flexDirection: "row",
        width: "90%",
        height: 50,
        alignItems: "center",
        justifyContent: "center",
        backgroundColor: "purple",
        margin: 16,
        borderRadius: 25
    },
    text:{
        color: "white",
        fontSize: 18,
        fontWeight: "bold",
        marginLeft: 8
    }
}) 

export default SuperButton;