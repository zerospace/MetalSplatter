import XCTest
import PLYIO

final class DataConvertibleTests: XCTestCase {
    static let floatValue: Float = 42.17
    static var floatValueLittleEndianData = Data([ 0x14, 0xae, 0x28, 0x42 ])
    static var floatValueBigEndianData = Data([ 0x42, 0x28, 0xae, 0x14 ])
    static let floatValuesCount = 1024
    static let floatValuesLittleEndianData = (0..<floatValuesCount).reduce(Data(), { data, _ in data + floatValueLittleEndianData })
    static let floatValuesBigEndianData = (0..<floatValuesCount).reduce(Data(), { data, _ in data + floatValueBigEndianData })

    func testFloat() {
        test(floatValuesData: Self.floatValuesLittleEndianData, bigEndian: false)
        test(floatValuesData: Self.floatValuesBigEndianData, bigEndian: true)
    }

    func test(floatValuesData: Data, bigEndian: Bool) {
        XCTAssertEqual(Float(floatValuesData, from: Self.floatValueLittleEndianData.startIndex, bigEndian: bigEndian),
                       Self.floatValue)
        XCTAssertEqual(Float(floatValuesData, from: Self.floatValueLittleEndianData.startIndex.advanced(by: 512), bigEndian: bigEndian),
                       Self.floatValue)
        XCTAssertEqual(Float(floatValuesData, bigEndian: bigEndian),
                       Self.floatValue)

        let arrayA = Float.array(floatValuesData, from: Float.byteWidth*10, count: Self.floatValuesCount-10, bigEndian: bigEndian)
        XCTAssert(arrayA.count == Self.floatValuesCount-10)
        XCTAssertEqual(arrayA[arrayA.count-1], Self.floatValue)

        let arrayB = Float.array(floatValuesData, count: Self.floatValuesCount, bigEndian: bigEndian)
        XCTAssert(arrayB.count == Self.floatValuesCount)
        XCTAssertEqual(arrayB[arrayB.count-1], Self.floatValue)
    }
}
