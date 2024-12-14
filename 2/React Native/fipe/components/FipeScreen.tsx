import { Colors } from '@/constants/Colors';
import styles from '@/styles';
import { View, Text, TextInput, TouchableOpacity, StatusBar, SafeAreaView, RefreshControl } from 'react-native'
import { FlashList } from '@shopify/flash-list'
import { useEffect, useState } from 'react';
import { FipeItem } from '@/models';
import Ionicons from '@expo/vector-icons/Ionicons'

interface FipeScreenProps {
    data?: Array<FipeItem>,
    handlePress: (item: FipeItem) => void,
    isLoading: boolean,
    update?: () => void
}

interface renderItemProps {
    item: FipeItem
}

const FipeScreen = (props: FipeScreenProps) => {
    const {data, handlePress, isLoading, update} = props;

    const [searchTerm, setSearchTerm] = useState<string>("");
    const [filteredData, setFilteredData] = useState<Array<FipeItem>>([])

    useEffect(() => {
        if (!data) return;
        const result = data.filter(item => item.nome.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase()))
        setFilteredData(result)
    }, [data, searchTerm])

    const renderItem = (props: renderItemProps) => {
        return (
            <TouchableOpacity style={styles.item} onPress={() => handlePress(props.item)}>
                <Text>{props.item.nome}</Text>
                <Ionicons name='chevron-forward' size={18}></Ionicons>
            </TouchableOpacity>
        )
    }

    return (
        <SafeAreaView style={styles.container}>
            <StatusBar barStyle={'dark-content'} ></StatusBar>
            <TextInput
                placeholderTextColor={Colors.text}
                style={styles.input}
                placeholder='Buscar ...'
                value={searchTerm}
                onChangeText={setSearchTerm}
            />

            <FlashList
                estimatedItemSize={60}
                data={filteredData}
                renderItem={renderItem}
                refreshControl={<RefreshControl refreshing={isLoading} onRefresh={update} />} />
        </SafeAreaView>
    );
}

export default FipeScreen;