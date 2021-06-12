package auth_test

import (
	"bytes"
	"fmt"
	"regexp"
	"strings"
	"testing"

	"git.chaos-hip.de/RepairCafe/PartMATE/auth"
	. "github.com/smartystreets/goconvey/convey"
)

var argonRegex = regexp.MustCompile(`^argon2id\|[0-9]+\|[0-9]+\|[0-9]+\|[0-9]+\|[a-z,A-Z,+,/,0-9]+\|[a-z,A-Z,+,/,0-9]+$`)

var hashTestCases = []string{
	"foo",
	"bar",
	"ruhfeuiwfohasorhf8gweiuhfojsojfhp9r74rzehofur589fhiu4twrp9ght4orflei5gkegr5ögiuhilu5rguukerjgioög5hirlkegnks.",
	`(&§/()W§U()R/(&/RT()§(ZGE/&W(E)=()/"R(ZT=(§R)ER/§(WO/TF&=§T(WDOGF§T/(WOD/G§/&=OR(WTOFgiwr§R§"E"()Z"G)/"T"§R()Z123t`,
	`Never gonna give you up
	Never gonna let you down
	Never gonna run around and desert you
	Never gonna make you cry
	Never gonna say goodbye
	Never gonna tell a lie and hurt you`,
	`😇😘🤟🏻🦠`,
	``,
}

func TestArgonHash(t *testing.T) {
	Convey("Having a set of hashing test-cases", t, func() {
		for i, testCase := range hashTestCases {
			Convey(fmt.Sprintf("[%d] Having an Argon2 hashed password", i), func() {
				hash, err := auth.NewArgonHash(testCase)
				So(err, ShouldBeNil)
				So(hash, ShouldNotBeNil)
				Convey("Using the same password with the same parameters should result in the same hash", func() {
					hash2, err := hash.HashPassword(testCase)
					So(err, ShouldBeNil)
					So(hash2, ShouldNotBeNil)
					a, ok := hash.(*auth.ArgonHash)
					So(ok, ShouldBeTrue)
					b, ok := hash2.(*auth.ArgonHash)
					So(ok, ShouldBeTrue)
					So(bytes.Equal(a.Key, b.Key), ShouldBeTrue)
					So(hash2.String(), ShouldEqual, hash.String())
				})
				Convey("Using 'Matches()' should work", func() {
					So(hash.Matches(testCase), ShouldBeTrue)
					So(hash.Matches(testCase+"foo"), ShouldBeFalse)
					if strings.ToUpper(testCase) != testCase {
						So(hash.Matches(strings.ToUpper(testCase)), ShouldBeFalse)
					}
				})
				Convey("Serializing and deserializing of the string variant should work", func() {
					serialized := hash.String()
					So(argonRegex.MatchString(serialized), ShouldBeTrue)
					out, err := auth.HashFromString(serialized)
					So(err, ShouldBeNil)
					So(out, ShouldNotBeNil)
					newHash, ok := out.(*auth.ArgonHash)
					So(ok, ShouldBeTrue)
					oldHash := hash.(*auth.ArgonHash)
					So(*newHash, ShouldResemble, *oldHash)
				})
			})
		}
	})
}

var hashStringTestCases = []struct {
	str string
	err string
}{
	{
		str: `argon2id|19|65536|3|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: ``,
	},
	{
		str: `xxx|19|65536|3|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for "xxx|`,
	},
	{
		str: `argon2id|xy|65536|3|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|23|cc23|3|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|1|65536|3;|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|23|65536|3||fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|19|65536|3|3|fvgovVöööV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|19|65536|3|3|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FPP§RövM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `unknown or illegal hash string - no matching hashing algorithm found for`,
	},
	{
		str: `argon2id|19|65536|3|1800|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `failed to decode 'parallelism' param from hash string: strconv.ParseUint: parsing "1800": value out of range`,
	},
	{
		str: `argon2id|19|65536|383479437289347928734892374327489|1|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `failed to decode 'iterations' param from hash string: strconv.ParseUint: parsing "383479437289347928734892374327489": value out of range`,
	},
	{
		str: `argon2id|19|65536347849723494732967973436927407563945732932|3|1|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: `failed to decode 'memory' param from hash string: strconv.ParseUint: parsing "65536347849723494732967973436927407563945732932": value out of range`,
	},
	{
		str: `argon2id|193209847238948079532959736907324945097435469823042|65536|3|1|fvgovVxGpNuV3GWiomo4C5WTN0yHHUV3bs1zYDz478I|KToZ/l5bPP3oXxwBjs1NXIpbnwGRa/VRLUBMfr/dbRw63wuZU8FvM0lL+yvOuTzDs1kni8FIZ21hoCYL6JqKvw`,
		err: ``,
	},
}

func TestArgonHashDeserialize(t *testing.T) {
	Convey("Having a set of encoded hashes", t, func() {
		for i, testCase := range hashStringTestCases {
			tc := testCase
			Convey(fmt.Sprintf("[%d] Decoding a hash from string", i), func() {
				hash, err := auth.HashFromString(tc.str)
				if tc.err == "" {
					Convey("Should decode the string successfully", func() {
						So(err, ShouldBeNil)
						So(hash, ShouldNotBeNil)
					})
				} else {
					Convey("Should fail decoding the string", func() {
						So(err, ShouldNotBeNil)
						So(hash, ShouldBeNil)
						So(err.Error(), ShouldContainSubstring, tc.err)
					})
				}
			})
		}
	})
}
