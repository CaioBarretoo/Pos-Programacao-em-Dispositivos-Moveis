import {Text, StyleSheet} from 'react-native'

interface ITitles{
    name: string,
    upperCase?: boolean;
}

const Title = ({name, upperCase}: ITitles) => {
    let value = name;
    if(upperCase){
        value = name.toUpperCase()
    }
 

    return(
        <Text style={styles.title}>{value}</Text> 
    ) 
}

const styles = StyleSheet.create({
    title: {
        fontSize: 16,
        fontWeight: "bold",
        color: "blue"
    }
})

export default Title;